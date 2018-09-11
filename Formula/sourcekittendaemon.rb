class Sourcekittendaemon < Formula
  desc "Swift Auto Completions for any Text Editor"
  homepage "https://github.com/terhechte/SourceKittenDaemon"
  url "https://github.com/terhechte/SourceKittenDaemon/archive/0.1.7.tar.gz"
  sha256 "ec43d644dc57a9555d29764c203961c0c9d55c4be6beb3270a6d77076fe2069c"

  def install
    system "make", "DESTDIR=#{prefix}"
  end

  test do
    system "false"
  end
end
