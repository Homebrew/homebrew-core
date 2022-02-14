class Rumble < Formula
  desc "RumbleDB 1.17.0 'Cacao tree' for Apache Spark"
  homepage "https://rumbledb.org/"
  url "https://github.com/RumbleDB/rumbledb-brew-zip/releases/download/v1.17.0/rumble-brew.zip"
  sha256 "21ebe235b3ff0e306eea3ce2d28f5186da0edf5c64236f5feb43e12309538d3d"
  license "MIT"

  depends_on "apache-spark"

  def install
    lib.install Dir["*"]
    bin.install Dir[lib/"bin/*"]
    bin.env_script_all_files(lib/"bin", SPARK_HOME_BIN: Formula["apache-spark"].bin)
  end

  test do
    assert_match "2",
      pipe_output(bin/"rumbledb -q '1+1'")
  end
end
