class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.9.1.tar.gz"
  sha256 "de4904fedb01bac6884b0d10aba35460cd74a7eb892d592a9ee3646a644a9702"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "84bd7915438109bb3cdbcdad456679e4643594b134fa7c47dec68f0f16d6b4fd"
    sha256 arm64_big_sur:  "624ff9536e97f1fcdc5fa028793b40df2656aec7701ee9f8fb8aee7fcf9b8e32"
    sha256 monterey:       "2af16e5a25f9043e8a8b23178ef15c9e60aee2191bc2b47c566c48c93fc23c60"
    sha256 big_sur:        "801c422ac266f59347857e0723defba25ba80d8c950bd5f488d4a7aac9b1901c"
    sha256 catalina:       "82a0f3e1298b8915d068c02b517d3a91343dc68d3476a27e2a2b8b8a0aa06084"
    sha256 x86_64_linux:   "7bcac51b06797d8e8abd3a41a4c1450f7e5c7414d54aa0c9a024df83a3c10879"
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
