class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v0.1.36.tar.gz"
  sha256 "42f9b0bf53ae44bc294be400e2c5259f977ffa4d5dbac3576b0b5e23d59791fd"

  bottle do
    cellar :any
    sha256 "9d6bef0fb54b13b9097256639284fd7b40d933f3fc339c207dff9185db5671a6" => :mojave
    sha256 "2dec904b0b3968b4c147209aa8a512f202ef69d609afdf4409aff4bea82a095e" => :high_sierra
    sha256 "ceb39e560a39f62ff4f73910612bf8c48648e3d9ea6373926bcc6c80203fb2bd" => :sierra
  end

  depends_on "go" => :build
  depends_on "gpgme"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/containers/skopeo").install buildpath.children
    cd "src/github.com/containers/skopeo" do
      system "make", "binary-local"
      bin.install "skopeo"
      prefix.install_metafiles
    end
  end

  test do
    cmd = "#{bin}/skopeo --override-os linux inspect docker://busybox"
    output = shell_output(cmd)
    assert_match "docker.io/library/busybox", output
  end
end
