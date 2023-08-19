class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.13.2.tar.gz"
  sha256 "1b5e7b4fcbc3b0ba5637793605a5bdc6372ec11e60306aef0ed29ec1fd64893f"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "aefd910bddbc2437f91ed4f0bc31cc201edece684a1cc35968b960123a52988f"
    sha256 arm64_monterey: "8501f93f511a9a4618e31d73a317ad60e29b24d31ac24fdf7428352e82944c20"
    sha256 arm64_big_sur:  "05f5dbd4d8314f39d77f45215ed92c82c54a953062a800ee037d912095295474"
    sha256 ventura:        "7ffba880f12ed55b48e91ff6c5bb58519f68b72b675e60a567836d7349b96f98"
    sha256 monterey:       "9be7819d82a91f5c56b9e6ff7b43934c267c850520daca9a48a16772e4f3c1a8"
    sha256 big_sur:        "f4c5d822afa696ddbdbf4bc4db2bcac63866f26e4b7ed7c7b5a712c0b2929bb3"
    sha256 x86_64_linux:   "069923f4c8961278bfc81f6804d5f7e659203aa20041975e92ecbc11a07e53bf"
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
