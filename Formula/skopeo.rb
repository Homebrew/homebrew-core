class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.5.2.tar.gz"
  sha256 "e15c189a8134dec62259e6fea2786e9fb55b34e55d26a8924de0d438fd3677c4"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "b9dadc6b8b0f2581a84f7759ca3816775b487ba3dbd6e5572abc1b2284d73c2a"
    sha256 arm64_big_sur:  "1736ebd503a81f71307c4c26733b81f98dc9f60b9d4677c2a1119b7a9b6db1cb"
    sha256 monterey:       "7547e1c21a8ee2d9ca367856520404e5e6016ae8ca866e6d52fa55c36ef92a73"
    sha256 big_sur:        "1647d44153158f265c270d58abc9f65af99deb31dae3a1a1efdae8244c18c3e5"
    sha256 catalina:       "55958aa578bfe7821270f8a04b0c34c3ffc8bb4146c942a93338d91056f9d21c"
    sha256 x86_64_linux:   "4c118063b2bdf11323d42545551cf6f372b96343faac1b58829c123794ca4a71"
  end

  depends_on "go" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV.append "CGO_FLAGS", ENV.cppflags
    ENV.append "CGO_FLAGS", Utils.safe_popen_read("#{Formula["gpgme"].bin}/gpgme-config", "--cflags")

    buildtags = [
      "containers_image_ostree_stub",
      Utils.safe_popen_read("hack/btrfs_tag.sh").chomp,
      Utils.safe_popen_read("hack/btrfs_installed_tag.sh").chomp,
      Utils.safe_popen_read("hack/libdm_tag.sh").chomp,
    ].uniq.join(" ")

    ldflags = [
      "-X main.gitCommit=",
      "-X github.com/containers/image/v5/docker.systemRegistriesDirPath=#{etc/"containers/registries.d"}",
      "-X github.com/containers/image/v5/internal/tmpdir.unixTempDirForBigFiles=/var/tmp",
      "-X github.com/containers/image/v5/signature.systemDefaultPolicyPath=#{etc/"containers/policy.json"}",
      "-X github.com/containers/image/v5/pkg/sysregistriesv2.systemRegistriesConfPath=" \
      "#{etc/"containers/registries.conf"}",
    ].join(" ")

    system "go", "build", "-tags", buildtags, "-ldflags", ldflags, *std_go_args, "./cmd/skopeo"

    (etc/"containers").install "default-policy.json" => "policy.json"
    (etc/"containers/registries.d").install "default.yaml"

    bash_completion.install "completions/bash/skopeo"
  end

  test do
    cmd = "#{bin}/skopeo --override-os linux inspect docker://busybox"
    output = shell_output(cmd)
    assert_match "docker.io/library/busybox", output

    # https://github.com/Homebrew/homebrew-core/pull/47766
    # https://github.com/Homebrew/homebrew-core/pull/45834
    assert_match(/Invalid destination name test: Invalid image name .+, expected colon-separated transport:reference/,
                 shell_output("#{bin}/skopeo copy docker://alpine test 2>&1", 1))
  end
end
