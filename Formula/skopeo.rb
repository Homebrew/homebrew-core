class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v0.1.38.tar.gz"
  sha256 "104ceb9c582dc5c3a49dd1752c4c326bba03f2f801596f089372e831f48ed705"
  revision 1

  bottle do
    cellar :any
    sha256 "440a3c2544571dca44df029d903c75ef92e9cdfe31d67b36f721d52934596a42" => :mojave
    sha256 "ff2ddfc7084e6ef15c973b4ac0e63ce3b4f9ae61effa62a061e470126f3bdd78" => :high_sierra
    sha256 "5e96313a0b8729fd42de2914eaa1ef2cc6777b93c4ac5173356d82e903539380" => :sierra
  end

  depends_on "go" => :build
  depends_on "gpgme"

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "1"
    ENV.append "CGO_FLAGS", ENV.cppflags
    ENV.append "CGO_FLAGS", Utils.popen_read("#{Formula["gpgme"].bin}/gpgme-config --cflags")

    (buildpath/"src/github.com/containers/skopeo").install buildpath.children
    cd buildpath/"src/github.com/containers/skopeo" do
      buildtags = [
        "containers_image_ostree_stub",
        Utils.popen_read("hack/btrfs_tag.sh").chomp,
        Utils.popen_read("hack/btrfs_installed_tag.sh").chomp,
        Utils.popen_read("hack/libdm_tag.sh").chomp,
        Utils.popen_read("hack/ostree_tag.sh").chomp,
      ].uniq.join(" ")

      ldflags = [
        "-X main.gitCommit=",
        "-X github.com/containers/skopeo/vendor/github.com/containers/image/docker.systemRegistriesDirPath=#{etc/"containers/registries.d"}",
        "-X github.com/containers/skopeo/vendor/github.com/containers/image/internal/tmpdir.unixTempDirForBigFiles=#{ENV["TEMPDIR"]}",
        "-X github.com/containers/skopeo/vendor/github.com/containers/image/signature.systemDefaultPolicyPath=#{etc/"containers/policy.json"}",
        "-X github.com/containers/skopeo/vendor/github.com/containers/image/sysregistries.systemRegistriesConfPath=#{etc/"containers/registries.conf"}",
      ].join(" ")

      system "go", "build", "-v", "-x", "-tags", buildtags, "-ldflags", ldflags, "-o", bin/"skopeo", "./cmd/skopeo"

      (etc/"containers").install "default-policy.json" => "policy.json"
      (etc/"containers/registries.d").install "default.yaml"

      prefix.install_metafiles
    end
  end

  test do
    cmd = "#{bin}/skopeo --override-os linux inspect docker://busybox"
    output = shell_output(cmd)
    assert_match "docker.io/library/busybox", output
  end
end
