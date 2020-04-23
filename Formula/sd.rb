class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/v0.7.4.tar.gz"
  sha256 "94064871151b472b72ed8ace353182a9d0cbba7a961921a37a27d382eb613426"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9cdd449bcfe0956157d9de33e4435edc3b3ee57316378aa3f7303cc5436d411" => :catalina
    sha256 "05a0730808a22ab931779e1669894031295d92eff4ec66af39cd2e6be616d484" => :mojave
    sha256 "4b1d873551f2934b59570b5a97c5458366751d7930eaceb356781e518f5f254b" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
