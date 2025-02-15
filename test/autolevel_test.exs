defmodule Image.AutoLevel.Test do
  use ExUnit.Case, async: true
  import Image.TestSupport

  test "Image.autolevel/1" do
    image_file = "puppy.webp"
    validate_file = "puppy_autolevel.jpg"

    image_path = image_path(image_file)
    validate_path = validate_path(validate_file)

    image = Image.open!(image_path, access: :random)
    {:ok, levelled} = Image.autolevel(image)

    # {:ok, _image} = Image.write(levelled, validate_path)
    assert_images_equal(levelled, validate_path, 4.6)
  end
end
