class ThingsSh < Formula
  desc "Simple read-only comand-line interface to your Things 3 database"
  homepage "https://github.com/AlexanderWillner/things.sh"
  url "https://github.com/AlexanderWillner/things.sh/archive/1.0.tar.gz"
  sha256 "a03a5b1032f48027fd3815422c6dd4633c94b575d8c99db4dad621ff1b1a0310"

  def install
    bin.install "things.sh"
  end

  test do
    system "true" # nothing really to test here
  end
end
