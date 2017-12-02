class Webbreaker < Formula
  desc "Webbreaker: Dynamic Application Security Test Orchestration"
  homepage "https://github.com/target/webbreaker"
  url "https://github.com/target/webbreaker/files/1512597/webbreaker-macos.zip"
  sha256 "f66d545cb29e2186315815ba6a8766b3f6024ca14807e46bcf807a401aea9902"
	version "2.0.2"

  def install
		bin.install "webbreaker-macos"
		system "mv #{prefix}/bin/webbreaker-macos #{prefix}/bin/webbreaker"
		bin.install_symlink "#{prefix}/bin/webbreaker" "webbreaker"
  end

  test do
    system "webbreaker"
  end
end
