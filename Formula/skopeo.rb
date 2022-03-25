class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.7.0.tar.gz"
  sha256 "453bdcce16767696ed71046b60ad7b34358b183b50eb5aa708ced0b5ea2927b1"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "d847acce1d6ff6f04d9b5eed16287b34adea46fa95d9034995dbeeb18c12b955"
    sha256 arm64_big_sur:  "eb7f06d7543f60d012ab00da61ce8a2e0eec7d45fc7289ef0b86839f5c81cb46"
    sha256 monterey:       "0ad59c0122397c8c6c5600049e9d8cc6d67455d268e3129a358fe90a7273da6b"
    sha256 big_sur:        "39057822c76b2106d5efc84f3892d5fa33c28b555bc30b6cc995ff876072351f"
    sha256 catalina:       "87cc982ab3988c6ceebc390d7bcc91395c90d052bdbf41948a4610cb1d917867"
    sha256 x86_64_linux:   "c32b50ca63ae96d6a0731809d98b0e7eaccb1f61fd4abcbef35846d27cfc5d5a"
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

    bash_completion.install "completions/bash/skopeo"
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
