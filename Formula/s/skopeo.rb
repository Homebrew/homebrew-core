class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/refs/tags/v1.22.2.tar.gz"
  sha256 "b6e1f208c1048f7a80613e8154774e6a3fdc891aeb45325c8ed905be4dee48d8"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "e36348d1a9b374d7e26ed244e22812b06b975c9e366dc86f062754b6e44333bd"
    sha256               arm64_sequoia: "4d748abe26a03304db741d3d4706166761648de067f92b6dfd9b9ff9b4318cac"
    sha256               arm64_sonoma:  "c2c419417107ef6d75bcc79cf55a0320fb3d74a8b13f6cc9c6fc2cc8b1af22d4"
    sha256 cellar: :any, sonoma:        "7cd6c9189287dafbd5007a79ea8e9bd53809f38f13417b9bf0c29fb6a4e61b03"
    sha256               arm64_linux:   "5055e6a401bf22ccc27841582a02214cb0c85b6d5c842424fb87728e63636c32"
    sha256               x86_64_linux:  "a04548ac4277a5c6e144814e5e4b99d56f70b98ab779ad6e107158d6bbc1e287"
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

    ldflag_prefix = "go.podman.io/image/v5"
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
