class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.9.2.tar.gz"
  sha256 "9a321ba75f213e5c46cba7f92073c2437137a56d3140c9ab6e723fb92890f9d0"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "93dcc0802f161c189d9f0ba007de04e38ddbb38c4429ae9aa109a4dde1b0f802"
    sha256 arm64_big_sur:  "1b3728dec3a4cb328b05d75709753ecd03d5f72f0b47610971df1b4a420623cf"
    sha256 monterey:       "94633cddfeb2723a259a9790a19a9ea597f60dc4726d77317e309595492d5ad3"
    sha256 big_sur:        "f09721ad0c8f8581c7f8cec0a8217ee738ee3ab9c168f2ce0d7d3a11ddfdbf98"
    sha256 catalina:       "acc6648e9999d45070753a9dbbb0d5a6ac66681cf80524c864ba7343f9f3615c"
    sha256 x86_64_linux:   "5adb9b435126f9d423702213e4da167b1bcf4ed53a29c0c4287b50c938e4854d"
  end

  depends_on "go" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV.append "CGO_FLAGS", ENV.cppflags
    ENV.append "CGO_FLAGS", Utils.safe_popen_read("#{Formula["gpgme"].bin}/gpgme-config", "--cflags")

    buildtags = [
      "containers_image_ostree_stub",
      Utils.safe_popen_read("hack/btrfs_tag.sh").chomp,
      Utils.safe_popen_read("hack/btrfs_installed_tag.sh").chomp,
      Utils.safe_popen_read("hack/libdm_tag.sh").chomp,
    ].uniq.join(" ")

    ldflags = [
      "-X main.gitCommit=",
      "-X github.com/containers/image/v5/docker.systemRegistriesDirPath=#{etc/"containers/registries.d"}",
      "-X github.com/containers/image/v5/internal/tmpdir.unixTempDirForBigFiles=/var/tmp",
      "-X github.com/containers/image/v5/signature.systemDefaultPolicyPath=#{etc/"containers/policy.json"}",
      "-X github.com/containers/image/v5/pkg/sysregistriesv2.systemRegistriesConfPath=" \
      "#{etc/"containers/registries.conf"}",
    ].join(" ")

    system "go", "build", "-tags", buildtags, "-ldflags", ldflags, *std_go_args, "./cmd/skopeo"

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
