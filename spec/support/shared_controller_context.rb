shared_context 'a successful index request' do
  it 'should be ok' do
    expect(response).to have_http_status(:ok)
  end

  it 'should render the index template' do
    expect(response).to render_template(:index)
  end
end

shared_context 'a successful new request' do
  it 'should be ok' do
    expect(response).to have_http_status(:ok)
  end

  it 'should render the index template' do
    expect(response).to render_template(:new)
  end
end

shared_context 'a successful create request' do |klass|
  it 'creates a record' do
    expect(klass.count).to eq(1)
  end

  it "should have a flash notice" do
    expect(flash[:notice]).to be_present
  end
end

shared_context 'a failed create request' do |klass|
  it 'should not create a record' do
    expect(klass.count).to eq(0)
  end
end

shared_context 'a successful delete request' do |klass|
  it 'should be deleted' do
    expect(klass.count).to eq(0)
  end
end

shared_context 'an unauthorized request' do
  it 'should return 401' do
    expect(response).to have_http_status(:unauthorized)
  end
end
