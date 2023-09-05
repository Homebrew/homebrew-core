class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.13.3.tar.gz"
  sha256 "0b788fc5725ac79327f7c29797821a2bafc1c3c87bbfcb2998c2a1be949e314d"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "1d994ad95fee2d772fc6d898ccc73a95dc36d89d2d006e74b59ef1975b20915a"
    sha256 arm64_monterey: "f959986de44422fe153764522a42280f2379dfe4a86304feb47cfc0fbe6421cc"
    sha256 arm64_big_sur:  "357eb35c2fced7a532d99989d4199b541db81004a13575801a57d52d7aa3ef54"
    sha256 ventura:        "303dc9bd484c043e2f99a53c99f8d6d16c0dca970ad58022e8790c75d9a1ac9b"
    sha256 monterey:       "7e9822bfc2cb9ba894b742818ea5a88e6ea2dae65541122a053226ab8678cd39"
    sha256 big_sur:        "aace59677bbb4b09e547735ec09feeeaafcfd6961d4fa8ce369b07c855c087e1"
    sha256 x86_64_linux:   "343ba543ce69fe7e5eb40dd00f8e91466da4a3fe63dec8bdf50d9be739ec55ca"
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
