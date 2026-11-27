class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/podman-container-tools/skopeo"
  url "https://github.com/podman-container-tools/skopeo/archive/refs/tags/v1.25.2.tar.gz"
  sha256 "d2ebe154195934908e2dd8d992bfda5dc554e1f5d8586c49b6a931fd69563d24"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "38b1273d6fbd24588927ca9d277018bf179479ddb064862d4fe9d7624352ded6"
    sha256 arm64_golden_gate: "97198a8f5aaa9b01de0b4780b0ef3edc75581ba3c0310f533e8c73dbc8d69617"
    sha256 arm64_tahoe:       "587e70941026a0b340773891dc6e0bf15646450ae9095349cc50bcea45f8fd2d"
    sha256 arm64_sequoia:     "6a6177e3e429105d1a33e5f17bc30528e094e431ea285c2135e6718c1e1c09c3"
    sha256 arm64_linux:       "d1fcb02e54bdf5c40e9cd2bc8d56f2138fb771d3b2d24864d4d1be1677f49193"
    sha256 x86_64_linux:      "33fd64e5b4dfa30fc267d154cfcf4c53978d56a65d8af4f66b391a44ef9cf325"
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
