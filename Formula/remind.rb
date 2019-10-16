class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-03.01.16.tar.gz"
  sha256 "eeb79bd4019d23a033fe3e86c672d960399db6a27c747e5b466ad55831dfca93"

  bottle do
    cellar :any_skip_relocation
    sha256 "444089059be6e06068947152227c92456a491c31e03663b3cf306c2858da1dc0" => :catalina
    sha256 "cf9cead0828acc09c9f93c45df372063167daaa46e336a7ef9c604310f92c51f" => :mojave
    sha256 "955b1f9a9a769c8d88814fee718237ea94ec2c537a3953cb01427815577ef84a" => :high_sierra
    sha256 "a2349249ca5fa9dcb92998f94b7b761636fa7c04c54c088798da92773c438e56" => :sierra
  end

  conflicts_with "rem", :because => "both install `rem` binaries"

  def install
    # Remove unnecessary sleeps when running on Apple
    inreplace "configure", "sleep 1", "true"
    inreplace "src/init.c" do |s|
      s.gsub! "sleep(5);", ""
      s.gsub! /rkrphgvba\(.\);/, ""
    end
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders").write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n", shell_output("#{bin}/remind reminders 2015-01-01")
  end
end
