class Zsync < Formula
  desc "File transfer program"
  homepage "https://zsync.moria.org.uk/"
  url "https://zsync.moria.org.uk/download/zsync-0.8.0.tar.gz"
  sha256 "58b02f27e14326b62b7fdd6ed431a3e243b1c5a3ea9e3c1678e136dbf00c238d"
  license "Artistic-2.0"
  head "https://github.com/cph6/zsync.git", branch: "master"

  livecheck do
    url "https://zsync.moria.org.uk/downloads"
    regex(/href=.*?zsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4acdec8c2fc88425b1389ac2839c04af8f182b5c19885ddf9dd6525074cd21e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4acdec8c2fc88425b1389ac2839c04af8f182b5c19885ddf9dd6525074cd21e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4acdec8c2fc88425b1389ac2839c04af8f182b5c19885ddf9dd6525074cd21e"
    sha256 cellar: :any_skip_relocation, sonoma:        "237ea6250c443d6e9f7fac829d9b320f1ddf5d1f0a84cf51eeca8b23e609a93e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f516760650bc9a934de177a23391b4c7c9758f6ae64c0d5881ebeb6655149241"
    sha256 cellar: :any,                 x86_64_linux:  "bd673f47540a39f84abbf844762e25920da491c01d6c792aaad07778568c80a5"
  end

  depends_on "go" => :build

  def install
    (buildpath/"cmd").each_child(false) do |cmd|
      system "go", "build", *std_go_args(output: bin/cmd), "./cmd/#{cmd}"
      man1.install "man/#{cmd}.1"
    end
  end

  test do
    touch testpath/"foo"
    system bin/"zsyncmake", "foo"
    sha256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
    assert_match "File-Hash: SHA-256:#{sha256}", (testpath/"foo.zsync").read
  end
end
