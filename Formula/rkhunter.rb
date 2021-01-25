class Rkhunter < Formula
  desc "Rootkit hunter"
  homepage "https://rkhunter.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/rkhunter/rkhunter/1.4.6/rkhunter-1.4.6.tar.gz"
  sha256 "f750aa3e22f839b637a073647510d7aa3adf7496e21f3c875b7a368c71d37487"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "398958bdafc37011a76efa6e6d2fefc8c34964eb6ba29a0f6823fb8c1058e9c5" => :big_sur
    sha256 "7d560c35e3fef71d00f5ea9ee54e3f175f39e0c3fabdd1e141cc247c2a886d91" => :arm64_big_sur
    sha256 "e9bfbf9e122295e1fd4ac70dea7502856b3415e0eec187512f196d51a718ab92" => :catalina
    sha256 "a174d252c029e7336a559e44e5ea7139c943addee52cf11fd1fd4c03d564cf52" => :mojave
    sha256 "35df7b4e420968fc71fc0fc0217716393c624594ff51245c80a969a5bb1569eb" => :high_sierra
    sha256 "8d00f31cf5150d841b22dd3c1cdda33dc8705075529f000d41678d05cb733e0f" => :sierra
    sha256 "1aca76cf8e890112cad63d353ca8369e301e0e990e5380bb5fc4236ded810147" => :el_capitan
  end

  def install
    system "./installer.sh", "--layout", "custom", prefix, "--install"
  end

  test do
    system "#{bin}/rkhunter", "--version"
  end
end
