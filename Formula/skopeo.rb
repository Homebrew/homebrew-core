class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.11.1.tar.gz"
  sha256 "7e2b327a687d2230e9075120fff1024e6c2f22738a4179030121c953dda7d3b5"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "8cc1befa9e0e99abc64e8f73b5e57483747218f5fdfaa7c5f0ad5c22f086a975"
    sha256 arm64_monterey: "9b8572116c6eb751631c8d985d0ee21a0b84875a998968e4c0964f623c1698fd"
    sha256 arm64_big_sur:  "73764fdca5ac8a8d3c8efe4cd6db381dbdcb6f6a4f5cfab8f1cc6a721b2c4512"
    sha256 ventura:        "1cbc0ee8e13287db93132f14e9c84c9470d19e01fb0742f06acfe95e2e269044"
    sha256 monterey:       "d503982282dbb31a1b4ab67b22129b0476b579727b7be0bf1b71cc748f5e5672"
    sha256 big_sur:        "0f4cfa6785ebe065f87cf798add17f2756be55034051f07dfde237cd7d1daec2"
    sha256 x86_64_linux:   "d1640b714e60e7dedae9aad7826343a068900a270d1a6f25f13c3d07ea115f3b"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "pkg-config" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV.append "CGO_FLAGS", ENV.cppflags
    ENV.append "CGO_FLAGS", Utils.safe_popen_read(Formula["gpgme"].opt_bin/"gpgme-config", "--cflags")

    buildtags = [
      "containers_image_ostree_stub",
      Utils.safe_popen_read("hack/btrfs_tag.sh").chomp,
      Utils.safe_popen_read("hack/btrfs_installed_tag.sh").chomp,
      Utils.safe_popen_read("hack/libdm_tag.sh").chomp,
    ].uniq.join(" ")

    ldflag_prefix = "github.com/containers/image/v5"
    ldflags = %W[
      -X main.gitCommit=
      -X #{ldflag_prefix}/docker.systemRegistriesDirPath=#{etc}/containers/registries.d
      -X #{ldflag_prefix}/internal/tmpdir.unixTempDirForBigFiles=/var/tmp
      -X #{ldflag_prefix}/signature.systemDefaultPolicyPath=#{etc}/containers/policy.json
      -X #{ldflag_prefix}/pkg/sysregistriesv2.systemRegistriesConfPath=#{etc}/containers/registries.conf
    ]

    system "go", "build", "-tags", buildtags, *std_go_args(ldflags: ldflags), "./cmd/skopeo"
    system "make", "PREFIX=#{prefix}", "GOMD2MAN=go-md2man", "install-docs"

    (etc/"containers").install "default-policy.json" => "policy.json"
    (etc/"containers/registries.d").install "default.yaml"

    generate_completions_from_executable(bin/"skopeo", "completion")
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
