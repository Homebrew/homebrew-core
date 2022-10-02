class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.10.0.tar.gz"
  sha256 "c3d15ec25c028980b795a0ccdcd48296287b8467fe24a7bc319f5fc87378fe8c"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "72324aa27b72c3c0912001b1ba835bb8b61e59d40da9ed8dd2deb95cc7bdaa40"
    sha256 arm64_big_sur:  "0303305a065ebbba53c901c1c742d5274b0e0e5b4637a884cb0c3d3e22dfac55"
    sha256 monterey:       "914444a0a8e10bed99c24d64cb433d00b797581377d945ca043fb2e4e7b3ae2e"
    sha256 big_sur:        "23cdf4566553fd854236e62bc4bf34d4977bb2616f12f4f1c161d4bdd883496b"
    sha256 catalina:       "68326240fa8f8afd691241f15eea76e2293fe30a9f8cb3f785782e0aadb96c4c"
    sha256 x86_64_linux:   "e574c8b6e799e08f28f744308d4a24e6a950537ab614ecd683ea226f25085d5f"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
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
