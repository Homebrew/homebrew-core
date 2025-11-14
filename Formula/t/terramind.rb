class Terramind < Formula
  desc "The AI coding agent built for the terminal"
  homepage "https://terramind.com"
  license "MIT"

  if OS.mac? && Hardware::CPU.arm?
    url "https://registry.npmjs.org/terramind-darwin-arm64/-/terramind-darwin-arm64-0.0.6.tgz"
    sha256 "ea12406ec6737e1c96c49c0ba5f170325210cd2ac354fc71de92b2b60711de79"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://registry.npmjs.org/terramind-darwin-x64/-/terramind-darwin-x64-0.0.6.tgz"
    sha256 "c4e45fad5fad4a239abc91c8bd1177d69f5d707948579a6b8f7c4a10dcf931fc"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://registry.npmjs.org/terramind-linux-arm64/-/terramind-linux-arm64-0.0.6.tgz"
    sha256 "d56ee71d54c5ac01cfbe10bb8c7d224e65e5986304fa4d995989d7cf754d748a"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://registry.npmjs.org/terramind-linux-x64/-/terramind-linux-x64-0.0.6.tgz"
    sha256 "d4e61d036d758e66388a79066158c731715b4579ec66eadf47a9427d327f0c3c"
  end

  def install
    # Extract the tarball contents
    bin.install "bin/terramind"
    
    # Set executable permissions
    chmod 0755, bin/"terramind"
  end

  test do
    system "#{bin}/terramind", "--version"
  end
end

