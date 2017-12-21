class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  url "http://cab.spbu.ru/files/release3.11.0/SPAdes-3.11.0.tar.gz"
  sha256 "308aa3e6c5fb00221a311a8d32c5e8030990356ae03002351eac10abb66bad1f"

  depends_on "cmake" => :build
  depends_on :python if MacOS.version <= :snow_leopard

  needs :openmp

  def install
    # Fix error: 'uint' does not name a type
    # Reported upstream: https://github.com/ablab/spades/issues/29
    # Will be fixed in the next release.
    inreplace "src/projects/ionhammer/config_struct.hpp", "uint", "unsigned"

    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
