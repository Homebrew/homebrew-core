class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/v1.0.0.tar.gz"
  sha256 "04edf69aca7b086328fa1a7bd8e06617ba074eaec041eda6bdad7a1ba0a00dee"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d9879ec4fb327d59a3b7104afa9bfdd449033f057d7d75ba1c3b7fbd56f731b" => :catalina
    sha256 "332214062ecf45642b0c4e15a03fd81b413cba778b45426d4a23ac3585e92bf0" => :mojave
    sha256 "b5aead139e53529995ed5cec83ee38e1146640249dca86e7cf66c293890f9e30" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"uni"
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
