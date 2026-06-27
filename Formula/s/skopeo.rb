class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "de96bfc2bb523c852af675ffdadd934484812ce190aa8620e1d5fd6c51442e25"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "b9bb3aa152bc76483a65dece4a7b9b4ffc09078bb0fe6c1c470145d901792eeb"
    sha256               arm64_sequoia: "42bd2618325948979d3d415758bbb9c237c3cc5b13c266604fcb8e3147f800d0"
    sha256               arm64_sonoma:  "e5d87f4b7cd3a682bfb5e244fd85a525a1e65af6ef0b45bc2b2e562ce34ae6c0"
    sha256 cellar: :any, sonoma:        "2ba12cb7f52c5935b83bc9fe3aeda780fdbbf718cb962609c8125dbc20341d79"
    sha256               arm64_linux:   "907ddddc81dcf26d0ca0b47621fd32c57efb0ad5f942346a0858ebd621f5a7ad"
    sha256               x86_64_linux:  "e992c01b75e47191bd4ed4c4d8cc10266a1812345374b4d987aff199e8b6b1d5"
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
