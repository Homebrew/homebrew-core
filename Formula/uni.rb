class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/v1.1.0.tar.gz"
  sha256 "938712d1e750b8dcea9f42d4691b66e15dbc7c7ce0200400f20f79702dc97bac"

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
