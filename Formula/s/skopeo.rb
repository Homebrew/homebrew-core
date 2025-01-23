class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "e548c044c7b644ba455f482df387ec90aceea432b9c61a0bab0ec8534970eb69"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "7e941ad32d87482f61ddecbc6796e2ef99bbd9d34a3a50398dcde72d1400d0cd"
    sha256 arm64_sonoma:  "9559e1f43d66b5c1c24fabf1ccc7b179a96964f665a2bb6d70c0e6531614e51c"
    sha256 arm64_ventura: "1ce91a6cac483d23c0fef98e731c8c4f71d46c21caa2a031f10fb89f9b6ef75b"
    sha256 sonoma:        "b4a0df0aaa27c9fdb61c66fffb540bb13084564b5e9b320d76c2466c93e359fd"
    sha256 ventura:       "1300e636939157e5541fd05b2a8f6ee6f1c0d824e51951e3b2bdc86efaf118c9"
    sha256 x86_64_linux:  "6c2715212a92c1b8bf905d82a90ecfb95846e379956aff28047b45fe841c908a"
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

    buildtags = [
      "containers_image_ostree_stub",
      Utils.safe_popen_read("hack/btrfs_tag.sh").chomp,
      Utils.safe_popen_read("hack/btrfs_installed_tag.sh").chomp,
      Utils.safe_popen_read("hack/libsubid_tag.sh").chomp,
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
