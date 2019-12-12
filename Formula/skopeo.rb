class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v0.1.40.tar.gz"
  sha256 "ee1e33245938fcb622f5864fac860e2d8bfa2fa907af4b5ffc3704ed0db46bbf"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "d382e6ed0f92e335d4b0c82bc535760dd7c32268f0b60dcb8ce7a09dbe4e1b5f" => :catalina
    sha256 "2c766d15ff4b798021ddb5c2eff823cefbbb20afb92da2e86e8e747dc891abbd" => :mojave
    sha256 "ae5437d6ba74269a0b82a85b365bbbdd0cf187107a44bf7119753d33e644947f" => :high_sierra
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
        "-X github.com/containers/image/v5/docker.systemRegistriesDirPath=#{etc/"containers/registries.d"}",
        "-X github.com/containers/image/v5/internal/tmpdir.unixTempDirForBigFiles=/var/tmp",
        "-X github.com/containers/image/v5/signature.systemDefaultPolicyPath=#{etc/"containers/policy.json"}",
        "-X github.com/containers/image/v5/pkg/sysregistriesv2.systemRegistriesConfPath=#{etc/"containers/registries.conf"}",
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
