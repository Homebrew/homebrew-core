class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.11.1.tar.gz"
  sha256 "7e2b327a687d2230e9075120fff1024e6c2f22738a4179030121c953dda7d3b5"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "76b74b964f712b7d4d738ab335f7f8a0440b2d23c79bc45a17db992ecdc7ebf2"
    sha256 arm64_monterey: "fe77834c1b64d38c6e8e05d6ce4dd4b2411ba75b90014f7cbbde2ab07db61b13"
    sha256 arm64_big_sur:  "7ed4a8eb1c647a8cdfda7595d50a879f48aab78c6c579e3eb83a7e0e99d3185d"
    sha256 ventura:        "af84d17459b1cd4d96beed9aa256065d6a68e1a4a00dc76746cf7e872dabe261"
    sha256 monterey:       "a977fc2d655bba9d255bd2a7c119e7eee8b49442331761d7969ab24f9d12c90e"
    sha256 big_sur:        "25879df278b18a306f4958432c107db523d853ae8b4d3d776d0dde7ab19c96fc"
    sha256 x86_64_linux:   "05df500542534428e6d51d3e2a0195ef495521110a494a503ad6149b708e3f0d"
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

    system "go", "build", "-tags", buildtags, *std_go_args(ldflags: ldflags), "./cmd/skopeo"
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
