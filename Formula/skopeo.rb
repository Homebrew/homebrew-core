class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.5.1.tar.gz"
  sha256 "624fd87dd8de7623f8c19c09715dd6b37820101e605ff5951cc512cf50d067a1"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "29db063738ec4c04fee481f510067bbed26028695b2ea9f986b8c6828150b8f5"
    sha256 arm64_big_sur:  "346a18940e9d5e798a846926c4a6ab0efd8ad3536fb1023c0aa49cb90da8f6b4"
    sha256 monterey:       "5ba669e644dcf927284cf28f1259cccc5f9e8afc6f8eeee170412673f25866c7"
    sha256 big_sur:        "790f5a0c5c284e721a33009f385a87f026f419f01077b29038e9a6490a190659"
    sha256 catalina:       "c5b4df87d4f83aab13448956272ab8bd4b5bde34e017112381d5ada24ae97347"
    sha256 x86_64_linux:   "ca9648444495e983b449ef5b41c3eeaaf51e606499be7177cc5e241b1de1a7b4"
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
