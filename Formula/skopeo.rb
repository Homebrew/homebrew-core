class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.12.0.tar.gz"
  sha256 "f7bbb3748eeb0c29abf5bfe9b1c1a149464c4ea65705e25686df3b9bcbd7bb89"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "9ab9308a9cdd9475761e1bfee40325ac8ea1fe55f3ae3eab57301dc064612127"
    sha256 arm64_monterey: "f8fadcde2bc673b670aeccc01cc01dd027c1f0993aed7774edd3b71ec36e7ef4"
    sha256 arm64_big_sur:  "369fc76c14952e6007358e3c9a869a45cada54dfeea9aafef5f319759a59572d"
    sha256 ventura:        "39e8a9865d76adb86ebfd04b1e6dc364f73eef69e17977dc833b1b5fa82d5eb7"
    sha256 monterey:       "0542ff4da60622f3dfd0167a7d2c1dbaf0b020251d7fa5c9e1ebb2777b0bab29"
    sha256 big_sur:        "1059fee8424df4a7c75333ff95e2435306f7ce9a3ebf99c23d95a3aa671697d2"
    sha256 x86_64_linux:   "c361bc757b2defcd4055012855f9a8686bf8fb5a1f43bb6d95049212f8a0281b"
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
