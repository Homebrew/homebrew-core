class TaskSpooler < Formula
  desc "Batch system to run tasks one after another"
  homepage "https://vicerveza.homeunix.net/~viric/soft/ts/"
  url "https://vicerveza.homeunix.net/~viric/soft/ts/ts-1.0.tar.gz"
  sha256 "4f53e34fff0bb24caaa44cdf7598fd02f3e5fa7cacaea43fa0d081d03ffbb395"

  bottle do
    cellar :any_skip_relocation
    sha256 "319c29e750b0ba183b14accb571c4d210723458d5fcd72302b5ec866e5a76ad4" => :mojave
    sha256 "8045397e275ade52621a1ab3a21e3eddf277fafd1beea60db2d10bc15d11b8f2" => :high_sierra
    sha256 "e0f7e33946d3f8c93782692b3bab5833cb2e882f1fb47a4473b69e39ce3e7378" => :sierra
    sha256 "9403d0c240bad09d576288d6b5ed94057dad03ceb30a4893a935c13f9e58af7f" => :el_capitan
  end

  if Tab.for_name("moreutils").with?("ts")
    conflicts_with "moreutils", :because => "both install a `ts` executable."
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ts", "-l"
  end
end
