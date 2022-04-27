class StylishHaskell < Formula
  desc "Haskell code prettifier"
  homepage "https://github.com/haskell/stylish-haskell"
  url "https://github.com/haskell/stylish-haskell/archive/v0.14.2.0.tar.gz"
  sha256 "e70081f863a406f0f048799d9fb2e6d92ad486bf9d5364609902155bfd2c3ea8"
  license "BSD-3-Clause"
  head "https://github.com/haskell/stylish-haskell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6301aa10585e2cd082f2f863a5721b6d44119dab2a36d53e43d975b6343a9a85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c42b253948357d0fa666dcd3d9d6b1569348de1838d7618ae9b1e582cf74df36"
    sha256 cellar: :any_skip_relocation, monterey:       "1b44fe90354d62504616bffe62b9e0c83f402dc4d0859beb0ada50bd82d3e75c"
    sha256 cellar: :any_skip_relocation, big_sur:        "550f3da427b05ee2b711dce1752bc5671417fff27291205fcfe2dfbd460c3caa"
    sha256 cellar: :any_skip_relocation, catalina:       "1b973b2809308f736b3be0b634df79fe367db4e0dee33121a51bce753dcdff9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40d7fe73c1a5681e378bf067eadb0d9f3d3e407ba7abb865172717c5e25a5a26"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~EOS
      {-# LANGUAGE ViewPatterns, TemplateHaskell #-}
      {-# LANGUAGE GeneralizedNewtypeDeriving,
                  ViewPatterns,
          ScopedTypeVariables #-}

      module Bad where

      import Control.Applicative ((<$>))
      import System.Directory (doesFileExist)

      import qualified Data.Map as M
      import      Data.Map    ((!), keys, Map)
    EOS
    expected = <<~EOS
      {-# LANGUAGE GeneralizedNewtypeDeriving #-}
      {-# LANGUAGE ScopedTypeVariables        #-}
      {-# LANGUAGE TemplateHaskell            #-}

      module Bad where

      import           Control.Applicative ((<$>))
      import           System.Directory    (doesFileExist)

      import           Data.Map            (Map, keys, (!))
      import qualified Data.Map            as M
    EOS
    assert_equal expected, shell_output("#{bin}/stylish-haskell test.hs")
  end
end
