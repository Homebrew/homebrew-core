# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2019.2.tar.gz"
  sha256 "1fde9d2a0df920a401441cd77253fc7b3b9ab0578eabda8caaaceaa6c7638440"
  depends_on "cmake" => :build

  resource "re2" do
    # DEPS
    url "https://github.com/google/re2.git",
        :revision => "6cf8ccd82dbaab2668e9b13596c68183c9ecd13f"
  end

  resource "effcee" do
    # DEPS
    url "https://github.com/google/effcee.git",
        :revision => "04b624799f5a9dbaf3fa1dbed2ba9dce2fc8dcf2"
  end

  resource "spirv-headers" do
    # DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        :revision => "e74c389f81915d0a48d6df1af83c3862c5ad85ab"
  end

  def install
    (buildpath/"external/re2").install resource("re2")
    (buildpath/"external/effcee").install resource("effcee")
    (buildpath/"external/SPIRV-Headers").install resource("spirv-headers")

    mkdir "build" do
      system "cmake", "..", "-DEFFCEE_BUILD_TESTING=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test SPIRV-Tools`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
