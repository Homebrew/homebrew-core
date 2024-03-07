class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "f0f5bc1367982d195c4bc13c003ee7ab0c829d36d808fe519accef64ebf5de23"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "cb0bff8d39cda79d8e495e2cf6eed4a89faf65d0ad5c12d0d66487a765f9e9e7"
    sha256 arm64_ventura:  "a283dd980ce189679ed1c03e83888aa64dfaa0da4734e66bd50b03eddef5d1a8"
    sha256 arm64_monterey: "4501bbf4dc94bc71f274af708574ee9705268aee6a7d47115eb8751e3e5b9767"
    sha256 sonoma:         "10d52fffa47490377d8e9cbb0dc9fd5fe71c13847eed6e70cfbcc93bb6d3d9da"
    sha256 ventura:        "3b7ad00a2849eb3e4e7699773161ae95a1e1e9816f9b4069c205ff1ddbaf4a39"
    sha256 monterey:       "480ddd9a6f10be051ea03c9ca02a1e8c244c54ab57a626ddb846637e01e8d4aa"
    sha256 x86_64_linux:   "06a0f2db68b16e60e0e05d2142f87bf7e722f82cf90fe28cb3a28e0a7bd3fc87"
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
