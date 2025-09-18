class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "0c19fe51b2cd8d1bd5e38c03b97421e318fc08153bdf5ef2f816a29889eacdef"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "0d0b4def1c9647842f565b8b63a71f68a4f82d650764008bbcd48994d26f2cf7"
    sha256 arm64_sequoia: "48fb54d9dfc643afa30a0b494a948c6a03333aa9364003db282d9135abb914a0"
    sha256 arm64_sonoma:  "8d2640e13bfb86252023095c04acd31a4b1ec06a3b07d5e3a61046c5c0669bcf"
    sha256 arm64_ventura: "aafd89323832b5b4f121a455f0c87e7e805e72ba85d1fa62edb3e7918ef883d1"
    sha256 sonoma:        "9be5e84aaea3ebfa9231ab1b5d9d0ed6eacdcaec9260d8c989484a1ee75ea5de"
    sha256 ventura:       "445eb2037a597f3d28d217d66509e5b4f5cd62b10de08226b0952b5c0296e5c6"
    sha256 arm64_linux:   "7dd90c80fe4078016c0d0add52a9874fac2c22dfa62ab08219ae9268aed6e09e"
    sha256 x86_64_linux:  "592cb52b502eb29da5ef94dce2afc60e804435129f2115a9b77301ca48622032"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV.append "CGO_FLAGS", ENV.cppflags
    ENV.append "CGO_FLAGS", Utils.safe_popen_read(Formula["gpgme"].opt_bin/"gpgme-config", "--cflags")

    tags = [
      "containers_image_ostree_stub",
      Utils.safe_popen_read("hack/btrfs_installed_tag.sh").chomp,
      Utils.safe_popen_read("hack/libsubid_tag.sh").chomp,
    ].uniq

    ldflag_prefix = "github.com/containers/image/v5"
    ldflags = %W[
      -X main.gitCommit=
      -X #{ldflag_prefix}/docker.systemRegistriesDirPath=#{etc}/containers/registries.d
      -X #{ldflag_prefix}/internal/tmpdir.unixTempDirForBigFiles=/var/tmp
      -X #{ldflag_prefix}/signature.systemDefaultPolicyPath=#{etc}/containers/policy.json
      -X #{ldflag_prefix}/pkg/sysregistriesv2.systemRegistriesConfPath=#{etc}/containers/registries.conf
    ]

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/skopeo"
    system "make", "PREFIX=#{prefix}", "GOMD2MAN=go-md2man", "install-docs"

    (etc/"containers").install "default-policy.json" => "policy.json"
    (etc/"containers/registries.d").install "default.yaml"

    generate_completions_from_executable(bin/"skopeo", "completion")
  end

  test do
    cmd = "#{bin}/skopeo --override-os linux inspect --no-creds docker://busybox"
    output = shell_output(cmd)
    assert_match "docker.io/library/busybox", output

    # https://github.com/Homebrew/homebrew-core/pull/47766
    # https://github.com/Homebrew/homebrew-core/pull/45834
    assert_match(/Invalid destination name test: Invalid image name .+, expected colon-separated transport:reference/,
                 shell_output("#{bin}/skopeo copy docker://alpine test 2>&1", 1))
  end
end
