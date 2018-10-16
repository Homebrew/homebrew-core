class Random < Formula
  desc "Command-line tool for doing random stuff 🎲"
  homepage "https://github.com/eneko/Random"
  url "https://github.com/eneko/Random/archive/0.1.0.tar.gz"
  sha256 "9c471b23afa18606b5ffc6cc0612bcda8e8e4a5be98b8f11d35ba8ebdd744fcb"

  depends_on :xcode => ["10", :build, :test]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc", "-static-stdlib"
    bin.install ".build/release/random"
  end

  test do
    assert_match "foo", shell_output("#{bin}/random pick foo foo foo")
    assert_match "foo", shell_output("#{bin}/random shuffle foo")
    assert_match "foo", shell_output("#{bin}/random shuffle foo foo foo")

    assert_match "foo", shell_output("echo foo foo foo | #{bin}/random pick")
    assert_match "foo", shell_output("echo foo | #{bin}/random shuffle")
    assert_match "foo", shell_output("echo foo foo foo | #{bin}/random shuffle")

    assert_match "bar\nbaz\nfoo", shell_output("#{bin}/random shuffle foo bar baz | sort")
    assert_match "bar\nbaz\nfoo", shell_output("echo foo bar baz | #{bin}/random shuffle | sort")
  end
end
