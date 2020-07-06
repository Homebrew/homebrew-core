class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.1.0.tar.gz"
  sha256 "3bd3acc614514fc2261b89dc0ea85ac7a4dba64fb7dcef8676ae61849e8faeb4"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 "753326edd62a8eef7b5e6fe41828d65f7515b9234865e050f76aca73520f1cd6" => :catalina
    sha256 "c0573c720ad51ded6e76420d1e9939b6ed04fc2f2f2eaaed726285c7c0230db3" => :mojave
    sha256 "76e3c0cb6daec487ffbbe50755faa297805bd287108eb7e3b9cd184842206b7b" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
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
    assert_match /Invalid destination name test: Invalid image name .+, expected colon-separated transport:reference/,
                 shell_output("#{bin}/skopeo copy docker://alpine test 2>&1", 1)
  end
end
