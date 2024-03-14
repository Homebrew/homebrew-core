class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "f219d31e5f3742b08a6e7327d84fd84cdcf8e5a297914bb6e19a96fef1b19b76"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "047ea5c5c94d0733c4ea702cc4fa4734f7bf8bf73e4c6ea9d10b8bc2ad9d3b07"
    sha256 arm64_ventura:  "80965fcf9c9f5fed4a659cb816fc327eeb2b8d20e091dc42f504f77bfc4573ba"
    sha256 arm64_monterey: "480e6333cb550b911bcfac32a9b3ba070231a515bb8891d49a752c380e2eabd0"
    sha256 sonoma:         "f59ddfa94a87cc5639002848327cdfd11eecf2b7db8b1af47c20e5182867f1e7"
    sha256 ventura:        "3f66a43e919d0218e35b6703871171a2b6187c0e5bbe4884d1d09c5f2b4c6ff8"
    sha256 monterey:       "76701d4e9acb3309c22a53dfac0dad8d00fc265b96114c4434fb9c074c0acb95"
    sha256 x86_64_linux:   "22aed2b29f4c849952eafa95ab423fe0f06cd93cf908c71816952d5c8210c1c8"
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

    system "go", "build", "-tags", buildtags, *std_go_args(ldflags:), "./cmd/skopeo"
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
