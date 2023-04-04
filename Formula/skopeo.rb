class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.11.2.tar.gz"
  sha256 "c7d0b0d1c379ae51e03e32ec31e243257d66de810d73704b7e9ac0e87cbec745"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "c442d45ad00417b2c3c397eb43e6f6bb21fee3e89b2ff4f2c3e2ef45b0f5358c"
    sha256 arm64_monterey: "4aa82ed1caa77321e064b58a6118385d5789fc24a4006482ffac3cc2b738b933"
    sha256 arm64_big_sur:  "8b2c01d4831655f354a70be208fa3bf58975560dedca64beae8ba547cc127f40"
    sha256 ventura:        "9950b9cad257e899ff674088f7c6412b03711f0160275ecfa20af2602db11565"
    sha256 monterey:       "9314700f2bbe0047a4d5c1e3334d2a8a0f59cd7f6b92a268e8cd174b5dc87af9"
    sha256 big_sur:        "e07a1a1935636f54ff3e14a14a5bf2520ca4ee288305f2413ef2d89efbb36f54"
    sha256 x86_64_linux:   "1ee0e459e1a9fbcadbb1a3ba2337c130b2932d922a9b782ecaf5840334610084"
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
