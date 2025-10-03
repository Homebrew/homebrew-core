class Serveit < Formula
  desc "Synchronous server and rebuilder of static content"
  homepage "https://github.com/garybernhardt/serveit"
  url "https://github.com/garybernhardt/serveit/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "5bbefdca878aab4a8c8a0c874c02a0a033cf4321121c9e006cb333d9bd7b6d52"
  license "MIT"
  revision 1
  head "https://github.com/garybernhardt/serveit.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5f667f37bc21e896dc225f76ca5755aa0c47d994928cc2a09ed06534fa3acc6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9f9a8523f4f530ab0bd0fad9a27c710efa442b2c964aafa32c4a747819c515b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f9a8523f4f530ab0bd0fad9a27c710efa442b2c964aafa32c4a747819c515b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f9a8523f4f530ab0bd0fad9a27c710efa442b2c964aafa32c4a747819c515b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f9a8523f4f530ab0bd0fad9a27c710efa442b2c964aafa32c4a747819c515b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f9a8523f4f530ab0bd0fad9a27c710efa442b2c964aafa32c4a747819c515b7"
    sha256 cellar: :any_skip_relocation, ventura:        "9f9a8523f4f530ab0bd0fad9a27c710efa442b2c964aafa32c4a747819c515b7"
    sha256 cellar: :any_skip_relocation, monterey:       "9f9a8523f4f530ab0bd0fad9a27c710efa442b2c964aafa32c4a747819c515b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "00ccf2f05dfd700cf0f862c6b9c1c250327d9d303fb6062f83133ff307c95197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e33ce3c0dbb5df24170e177bf1f0246d923e061304e201b54ed3f78051687a2d"
  end

  uses_from_macos "ruby"

  # webrick is needed for ruby 3.0+ (as it is not part of the default gems)
  # upstream report, https://github.com/garybernhardt/serveit/issues/13
  resource "webrick" do
    on_linux do
      url "https://rubygems.org/downloads/webrick-1.8.1.gem"
      sha256 "19411ec6912911fd3df13559110127ea2badd0c035f7762873f58afc803e158f"
    end
  end

  def install
    bin.install "serveit"

    if OS.linux?
      ENV["GEM_HOME"] = libexec
      resources.each do |r|
        r.fetch
        system "gem", "install", r.cached_download, "--no-document",
                      "--install-dir", libexec
      end

      bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    end
  end

  test do
    port = free_port
    pid = fork { exec bin/"serveit", "-p", port.to_s }
    sleep 2
    assert_match(/Listing for/, shell_output("curl localhost:#{port}"))
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
