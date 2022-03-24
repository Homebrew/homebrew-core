class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.7.0.tar.gz"
  sha256 "453bdcce16767696ed71046b60ad7b34358b183b50eb5aa708ced0b5ea2927b1"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "ad561076bf6ca10ad97ebd91a1159abcbae4c2a71c3e6914c7cd0f2de71efe6b"
    sha256 arm64_big_sur:  "6dc9f207905931482178d7be433c873bf51159512b1717297873bce7b74b9f4e"
    sha256 monterey:       "636b4ac8d96a380d4e4297dfea339a3bcb8afb9ada68ee1ce590b44b8b881c45"
    sha256 big_sur:        "857d37750e565781bcf2a90e0d955107d41b11ccfa1e51661d70a63d75a1b396"
    sha256 catalina:       "d1b97fd4e6e111462f1cdd40bb2e66c7e194b4cabb7148347d2aec9d21a32f32"
    sha256 x86_64_linux:   "e1009bc3dd218b1b2da1f657925f95e3af829ccc8d97d80a3f8921822ac54e9c"
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
