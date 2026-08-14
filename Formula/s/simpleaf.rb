class Simpleaf < Formula
  desc "Rust framework to make using alevin-fry even simpler"
  homepage "https://simpleaf.readthedocs.io/"
  url "https://github.com/COMBINE-lab/simpleaf/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "8a8f4968e42964b976ef6e8df4f8278ef15ff233ea3c01c0ef9b43ace8b068b9"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/simpleaf.git", branch: "main"

  # hdf5-metno-sys is pulled in via af-anndata -> anndata-hdf5, which enables its
  # `static` feature unconditionally, so HDF5 is always built from vendored sources.
  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    # The vendored HDF5 build records `CMAKE_C_COMPILER` in its build settings
    # blob, which ends up in the binary, so bypass the compiler shims.
    ENV["CC"] = DevelopmentTools.locate(ENV.cc)
    ENV["CXX"] = DevelopmentTools.locate(ENV.cxx)

    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["ALEVIN_FRY_HOME"] = testpath

    (testpath/"chemistries.json").write <<~JSON
      {
        "brew-test-chem": {
          "geometry": "1{b[16]u[12]x:}2{r:}",
          "expected_ori": "fw",
          "version": "0.1.0"
        }
      }
    JSON

    output = shell_output("#{bin}/simpleaf chemistry lookup --name brew-test-chem")
    assert_match "1{b[16]u[12]x:}2{r:}", output
    assert_match "fw", output

    assert_match version.to_s, shell_output("#{bin}/simpleaf --version")
  end
end
