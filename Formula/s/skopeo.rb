class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/podman-container-tools/skopeo"
  url "https://github.com/podman-container-tools/skopeo/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "6a3f342a327ec7684198eb0e15114940b6101506db48d9a96590f5942cb3b335"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "2495e972107dc5585aa717819abe418502eff9c0f9c89448401b8fe1590b4e43"
    sha256 arm64_tahoe:       "efd52716aa3a6530509482147fc0d1d1555a5d815cff3384c45a70c996f8ddcd"
    sha256 arm64_sequoia:     "3f11c07daafc82339cd18de22f071c0c4e1068574e3e6aa429e06c4cbcb294fb"
    sha256 arm64_linux:       "143acd2c195e7ac32aca1b514539cfbab7b8d98cfc2ec63cb62d825a4ae03274"
    sha256 x86_64_linux:      "cc76368dd7672bdccb6a160231871a58357f94aeef7a07608a9f9d9fac4fd941"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "device-mapper"
  end

  # `test do` block inspects an image on Docker Hub
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV.append "CGO_FLAGS", ENV.cppflags
    ENV.append "CGO_FLAGS", Utils.safe_popen_read(formula_opt_bin("gpgme")/"gpgme-config", "--cflags")

    tags = [
      "containers_image_ostree_stub",
      Utils.safe_popen_read("hack/btrfs_installed_tag.sh").chomp,
      Utils.safe_popen_read("hack/libsubid_tag.sh").chomp,
    ].uniq

    ldflag_image_prefix = "go.podman.io/image/v5"
    ldflag_storage_prefix = "go.podman.io/storage"
    ldflags = %W[
      -X main.gitCommit=
      -X #{ldflag_image_prefix}/docker.systemRegistriesDirPath=#{etc}/containers/registries.d
      -X #{ldflag_image_prefix}/internal/tmpdir.unixTempDirForBigFiles=/var/tmp
      -X #{ldflag_storage_prefix}/pkg/configfile.systemConfigPath=#{etc}/containers
      -X #{ldflag_image_prefix}/pkg/sysregistriesv2.systemRegistriesConfPath=#{etc}/containers/registries.conf
    ]

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/skopeo"
    system "make", "PREFIX=#{prefix}", "GOMD2MAN=go-md2man", "install-docs"

    (etc/"containers").install "default-policy.json" => "policy.json"
    (etc/"containers/registries.d").install "default.yaml"

    generate_completions_from_executable(bin/"skopeo", shell_parameter_format: :cobra)
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
