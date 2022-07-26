class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.9.1.tar.gz"
  sha256 "de4904fedb01bac6884b0d10aba35460cd74a7eb892d592a9ee3646a644a9702"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "779f16478ba16a364e6bf6b46a3777269c63a054cfddb4963dcbe5c6ec2f0bdd"
    sha256 arm64_big_sur:  "d0e23d06a94fac39f6996dc95633f6de9798a46aa7bbc43bcb55f1a812a5cbe7"
    sha256 monterey:       "f6516806331cf3eab67e3401fd3241c4d4e495315d31033adce58c2c06caa58b"
    sha256 big_sur:        "85dad2ef4303385f294f61de355f243faa6f6f423eff936a79ec9b0de0349e45"
    sha256 catalina:       "258a9766bdfbb5e1c314f4c363c443b40dc5e3ef635a0b480be22871ce995a1e"
    sha256 x86_64_linux:   "6606f1f1c6c810658e64fcf44453a044438ffc679e3c20038d39e64318bb868c"
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

    bash_output = Utils.safe_popen_read(bin/"skopeo", "completion", "bash")
    (bash_completion/"skopeo").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"skopeo", "completion", "zsh")
    (zsh_completion/"_skopeo").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"skopeo", "completion", "fish")
    (fish_completion/"skopeo.fish").write fish_output
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
