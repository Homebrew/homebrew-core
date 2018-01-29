class Virtualgo < Formula
  desc "Easy and powerful workspace based development for Go"
  homepage "https://github.com/GetStream/vg"
  url "https://github.com/GetStream/vg/archive/v0.8.0.tar.gz"
  sha256 "e7267b1306c36b3a4a4d10cb9e7ece66a9436a430bbf15028b82313496c92ebe"

  depends_on "go" => :build
  depends_on "dep" => :build
  depends_on "bindfs"

  def install
    ENV["GOPATH"] = buildpath
    vgpath = buildpath/"src/github.com/GetStream/vg"
    vgpath.install buildpath.children
    cd vgpath do
      system "dep", "ensure"
      system "go", "build", "-o", bin/"vg",
        "-ldflags", "-w -s -X github.com/GetStream/vg/cmd.Version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vg version")
  end
end
