class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.0.tar.gz"
  sha256 "849abeaf750750c2b865e2540630a799dce0dcaf84ff574ccad22c8f66577531"
  head "https://github.com/subfinder/subfinder.git"

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/projectdiscovery/subfinder/"
    path.install buildpath.children

    cd path do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", "#{bin}/subfinder", "cmd/subfinder/main.go"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/subfinder", "-config", "output.txt"
    assert_predicate testpath/"output.txt", :exist
  end
end
