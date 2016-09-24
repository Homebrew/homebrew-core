class Redo < Formula
  desc "Implements djb's redo: an alternative to make(1)"
  homepage "https://github.com/apenwarr/redo"
  url "https://github.com/apenwarr/redo/archive/redo-0.11.tar.gz"
  sha256 "2d7743e1389b538e2bd06117779204058fc0fcc0e05fd5ae14791d7f3fc3bcfa"

  bottle do
    sha256 "1100591f6491ecede9896fbe1608277faaaaa002a170f4e0f7372e1f1a98eca1" => :el_capitan
    sha256 "e83a1a2519401dcc187310f1b12c3063f32cee2ca76a003b7cf8a5d873779c90" => :yosemite
    sha256 "c0c79234b90f83ca99b7dfea11834ee123bc581ba3822201950be7fe3c82afe2" => :mavericks
  end

  resource "docs" do
    url "https://github.com/apenwarr/redo.git", :branch => "man"
  end

  def install
    ENV["PREFIX"] = prefix
    system "./redo install"
    rm share/"doc/redo/README.md" # lets not have two copies
    man1.install resource("docs")
  end
end
