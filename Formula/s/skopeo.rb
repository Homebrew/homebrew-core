class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/podman-container-tools/skopeo"
  url "https://github.com/podman-container-tools/skopeo/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "8e889df322ec3d9457a2e3b61ba9fa77759dd81dac857514333fb3b837e98b65"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "c3ca85fab345aceaac96b80481245cbc6719f07c9c3e97f97eda174db8da5724"
    sha256 arm64_tahoe:       "a420033ca34bf2fc232f807f6eb76a36cd7d0ef158638acc6bc44de054be28e7"
    sha256 arm64_sequoia:     "cf2c5f29b9243e4965332ac68c5732408b3164b6c112d4debc60efed95d68aae"
    sha256 arm64_linux:       "f118dd1b4c6440d61b2ae193156ae6085f449b56140ce80e03584279b325eb00"
    sha256 x86_64_linux:      "e92eca0b10b3be146d174d61a23444b0921e1f3e95c87676de6dda3e2a5ea75e"
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
    output = shell_output("#{bin}/skopeo copy docker://alpine test 2>&1", 1)
    assert_match(/invalid destination name test: Invalid image name .+, expected colon-separated/i, output)
  end
end
