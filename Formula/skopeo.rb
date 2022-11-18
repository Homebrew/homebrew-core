class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.10.0.tar.gz"
  sha256 "c3d15ec25c028980b795a0ccdcd48296287b8467fe24a7bc319f5fc87378fe8c"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "37a075621614abd79bcbfb9c5c64abab1fad493e47d19bb1cd0f1630adb514e2"
    sha256 arm64_monterey: "d5ffca5e5e85871bc9f5da16eda4c1e18e8cab435f7e8e7630655022fdd7efd2"
    sha256 arm64_big_sur:  "264d7c9a3d78d57889363310fc0b0d89805ca6c9000bfedb9add7ed8fcce5772"
    sha256 ventura:        "3b70efb4bbe9ea12a936aa8ad293c66bd98a86f49448c7c80e6c744eedf8d6b1"
    sha256 monterey:       "fc7d4b2710a7bc49beb21d0b7bb71c9497318b265a2fdb4c69e5b7c037d2961c"
    sha256 big_sur:        "cd303761c608ef66899e7b1c0734056666b0ab5f7c55389e107cbe949161d8a4"
    sha256 catalina:       "bc7aaddfad6cfa1d1025d7349ca5eaa6bd1ec5621d1e072d2bed68ce35adb726"
    sha256 x86_64_linux:   "e34add25f82193fd872cf1cddaf62c015cd22c88a98d8e85738c5ef53ce4e4ba"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
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
