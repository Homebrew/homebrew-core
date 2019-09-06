class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v0.1.38.tar.gz"
  sha256 "104ceb9c582dc5c3a49dd1752c4c326bba03f2f801596f089372e831f48ed705"
  revision 1

  bottle do
    sha256 "968f179e2ffacc33a4442e212d1dd789be35a250490f80fb862cd9777559134c" => :mojave
    sha256 "9b8acfee75274b2c7ee46183e893cbd67c6dfecdad7391094d8a7c326101c413" => :high_sierra
    sha256 "86d4a6c35cf115708e8027af5732ce5feba864112f97498b49ec354fe98b38f0" => :sierra
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
