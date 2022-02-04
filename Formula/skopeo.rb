class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.6.0.tar.gz"
  sha256 "95d63d786e7efda7711fbbad6e37edf53ac767eaa47a63dc56c19bbd95add2cd"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "3579dde9dbd3169762f15945918dfd5e04b6e1ee7c2b274233ff638d4a98b722"
    sha256 arm64_big_sur:  "5071dd3f01d6f4ae59b9e174effaa2f9607dea5460af15f1372392ac7f7544ca"
    sha256 monterey:       "f9299cbb2557bb186161dd11036703d1298f9523d5c5cf188770e39be7bf208a"
    sha256 big_sur:        "ba1f436b26c384b0a7faeb03fcb6202f6a073a0e076c441d7c1d8e6f4bf7ac6d"
    sha256 catalina:       "63befbd7fbe8c91a07261147172baefc0ee67435a6723359fa6979f75319b2fb"
    sha256 x86_64_linux:   "e0f27518474fafdec8a14ea4cbf21573d1a261f8d4faebdce2a36d9d9261b945"
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
