class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "f76eeddf697a3cc7a872e3077ab4d0fdbebe9f3c6171462e3e9feb84368b3fac"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "1878c928f210477b2ad9cee8a3039d5f009d0183e2d8bb80593fb572b2dc55b9"
    sha256               arm64_sequoia: "c0326e1463f60304b1f2f17da53d3df06ef16b922f61773c4fdd73a020d30f53"
    sha256               arm64_sonoma:  "84c516aabdbd1bd1ffa77e7889d39f950f83c8f0a6f4125fb1609d0851b5ee65"
    sha256 cellar: :any, sonoma:        "0a7b4a8f3293b70ffd6bfdfc7a788005a6cd57616a69a635db5c943ed844cdf0"
    sha256               arm64_linux:   "3c36ef5de51d21386ed8ede6c1ac229abfadba10b666366dc09bd96a59108355"
    sha256               x86_64_linux:  "abf6d2bc1c9f4e180b00468e7ea272870042f0da2ce03cffac7dbd5e3244b85c"
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
