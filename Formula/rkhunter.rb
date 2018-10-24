class Rkhunter < Formula
  desc "Rootkit hunter"
  homepage "https://rkhunter.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/rkhunter/rkhunter/1.4.6/rkhunter-1.4.6.tar.gz"
  sha256 "f750aa3e22f839b637a073647510d7aa3adf7496e21f3c875b7a368c71d37487"

  bottle do
    cellar :any_skip_relocation
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
