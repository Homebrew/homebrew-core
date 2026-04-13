class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "b4db7a6afc7ad07d4880ea425dd5ad26b6cf29b9a65bf94145e7568f34b95f23"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "820f1e619424d20c3f77ee3cf2baad88ac93eb3e66bd474ac6ac4a77d568a3f8"
    sha256               arm64_sequoia: "daaece713265058707f1a6fb4328749197822565e5e9e9ca2b41038fca52dcf1"
    sha256               arm64_sonoma:  "466981c2f3fc1ee4991685d025e15e5f9fd7bfca702e10aa5659dcd6ce2bbe28"
    sha256 cellar: :any, sonoma:        "4f1d91ea4613f443765a288c7bc7b8504985f5b6ad2b5610c5bd8ec2e4fe6f4c"
    sha256               arm64_linux:   "64aa7f1c366ecce65e806a806cf9d0046a565784c6feeba6915765e898817b48"
    sha256               x86_64_linux:  "04d98f6ae98a3088f914206ff04ec30f47f97ed699c908448cb42db3b2c97017"
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
