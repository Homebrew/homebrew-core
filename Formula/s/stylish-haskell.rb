class StylishHaskell < Formula
  desc "Haskell code prettifier"
  homepage "https://github.com/haskell/stylish-haskell"
  url "https://github.com/haskell/stylish-haskell/archive/v0.14.5.0.tar.gz"
  sha256 "580af1dc2f2cc3089bb255fd0af15dfb795a9ba0d9e76b2d0ce0c9ed2bcd9f07"
  license "BSD-3-Clause"
  head "https://github.com/haskell/stylish-haskell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "281a939e6a664fc7cb85c922307d4134e29522c5c87874e18c258af5ce11287f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebcb0f2e0492c9b6c43968307057cd61ca25261d6a23b9aee234dd44159375e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abfcbc6d42648effa6e217618b6dde78e9cbe16ffef15b21cd04846118c2b602"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b93ee0b5f1989e2d4badf31b60d2a3bb32d0e149ba77e00796a4c2e5ab7b2eb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "01d2abf664c1af4c486e62c966cb3323e0237c32e8d63edcc44416863edc7a81"
    sha256 cellar: :any_skip_relocation, ventura:        "94a60062523ee32639defa223cf1a9635aad22ebc4671e90d673bee8f7640d46"
    sha256 cellar: :any_skip_relocation, monterey:       "9712b2e0ad967d398abb46ea9bd4800016b96ceefb67b871aec901089e752289"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e7a9133a1ce54a317450e4a8f1a6651561968d779e29d112585c3d422faead5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6ea28db8324623c8190445021b20c95b515b48dcf84fdf9011a308de125cd45"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    # Work around build failure by enabling `ghc-lib` flag
    # lib/Language/Haskell/Stylish/GHC.hs:71:51: error:
    #     • Couldn't match expected type 'GHC.LlvmConfig'
    #                   with actual type 'ghc-lib-parser-9.4.3.20221104:GHC.Driver.Session.LlvmConfig'
    # Issue ref: https://github.com/haskell/stylish-haskell/issues/405
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+ghc-lib"
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
